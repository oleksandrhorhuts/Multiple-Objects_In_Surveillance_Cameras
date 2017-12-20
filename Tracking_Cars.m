% function [] = Tracking_Car(file_name)
% This function is the main entrance
% Inputs:
%           file_name:         string
% Outputs:

function Tracking_Car(file_name)
    global obj;
    global tracks;
    obj = setupSystemObjects(file_name);
    tracks = initializeTracks(); % Create an empty array of tracks.

    nextId = 1; % ID of the next track
    showId = 1;
    while ~isDone(obj.reader)
        frame = obj.reader.step();
%      figure,imshow( frame ,[]);title('Raw');
        [centroids, bboxes, mask] = detectObjects(frame);

        predictNewLocationsOfTracks();
        [assignments, unassignedTracks, unassignedDetections] = ...
        detectionToTrackAssignment(centroids);

        updateAssignedTracks(assignments,centroids, bboxes);
        updateUnassignedTracks(unassignedTracks);
        deleteLostTracks();
        [nextId]=createNewTracks(centroids, unassignedDetections, bboxes,nextId);
        showId= displayTrackingResults(frame,mask,showId);
    %     obj.maskPlayer.step(mask);
    end
%             close all;
end