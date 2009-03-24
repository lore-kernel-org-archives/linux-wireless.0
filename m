Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f118.google.com ([209.85.221.118]:42756 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbZCXSIi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 14:08:38 -0400
Received: by qyk16 with SMTP id 16so3517077qyk.33
        for <linux-wireless@vger.kernel.org>; Tue, 24 Mar 2009 11:08:35 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 24 Mar 2009 23:38:19 +0530
Message-ID: <68f4d6130903241108j590d49adj10446169f7c3c06b@mail.gmail.com> (sfid-20090324_190840_939498_34F9DD29)
Subject: GSoC '09 applicant : Introduction
From: k roy <kroykroy@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I guess that I am pretty late at introducing myself in this mailing
list but I will do it nevertheless. My name is Kalpana Roy, a final
year student from India, pursuing her B.Tech(I.T.) degree. Inspite of
being in my final year this will be my first (probably the last too)
attempt at GSoC. I was introduced to the wonderful world of FOSS by
another FOSS enthusist who also successfully completed his GSoC
project last year. Uptil then, my only interaction with FOSS was using
the softwares but now I am looking into development aspects and want
to contribute as well.
I worked on an open-source project last year and created a
GUI-cum-editor for VPython. As I did not interact with the core
developers, my work could never be included in the VPython module. I
learned this through GSoC, that communication is as important as
contribution, and that the work you do is of no use if you just keep
it to yourself.
My skill-set includes working in languages C++,PHP and familiarity
with PyGtk, Java, MySQL. I mostly work on Linux systems (Ubuntu and
Fedora being my distros of choice) though I have a dual boot machine
with Windows installed as well.
The project which I would like to work on, under Linux Foundations is
Integration of Geoclue with linux kernel and gnome-desktop. As
suggested by Luis R. Rodriguez, who has agreed to comentor this
project, it will be a combined project under both Linux Foundations
and Gnome developers. Under the Gnome-desktop cover, I would work to
include location-sensitivity functionality to various gnome
applications like Tracker, Empathy, Gwibber, Evolution, Clock and use
of OpenStreetMap and libchamplain library to display a map of the
locality. The comments which I receive for the above proposal was that
it was too short compared to GSoC and it only included submitting
patches to a few gnome applications. Now since, the project will
include providing Geoclue information to the Network Manager and
currectly deducing the country based on the timezone provided by the
user using Geoclue, I guess the project is big enough. Infact Geoclue
does the automatic finding of the location (Geotargetting) based on IP
address. It uses the database of hostip.info site for the same.
I conversed about the merging of the two project ideas with Jussi
Kukkonen, who is the major developer of Geoclue, and he expressed his
views about it being a great idea but he said that geoclue cannot (in
many cases) make guarantees on the correctness of results so using
them for "regulatory compliance" should be done with understanding
that. Example: wlan positioning is based on access point MAC address
and the manufacturers are known to make mistakes with those, so there
may be two devices out there with the same MAC address but totally
different locations. If the afore-mentioned is acceptable then it is a
great idea.I am planning to submit the project proposal under both
Gnome as well as Linux Foundations, however if accepted under any, it
will needed to be comentored by both the organisation's developers. I
am working on the application and it should be ready within 1-2 days
span. I am also looking forward to any comments/suggestions regarding
the project.
My contact details are as follows:
email : kroykroy@gmail.com
IM (XMPP) : kroykroy@gmail.com
IRC nick : kr0y
weblog : http://wannabe-a-geek.blogspot.com/

Looking forward to hearing from you,
~kr0y.
