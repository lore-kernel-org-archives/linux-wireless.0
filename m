Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:57347 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757305AbZCXT42 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 15:56:28 -0400
Received: by wf-out-1314.google.com with SMTP id 29so3598713wff.4
        for <linux-wireless@vger.kernel.org>; Tue, 24 Mar 2009 12:56:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <68f4d6130903241108j590d49adj10446169f7c3c06b@mail.gmail.com>
References: <68f4d6130903241108j590d49adj10446169f7c3c06b@mail.gmail.com>
Date: Tue, 24 Mar 2009 12:56:11 -0700
Message-ID: <43e72e890903241256l39f5b1f9i49ce2b7a6e8099c3@mail.gmail.com> (sfid-20090324_205631_730408_17D74C12)
Subject: Re: GSoC '09 applicant : Introduction
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: k roy <kroykroy@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Jussi Kukkonen <jku@linux.intel.com>,
	Till Kamppeter <till.kamppeter@gmail.com>,
	Marcel Holtmann <marcel@holtmann.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 24, 2009 at 11:08 AM, k roy <kroykroy@gmail.com> wrote:
> Hello,
>
> I guess that I am pretty late at introducing myself in this mailing
> list but I will do it nevertheless. My name is Kalpana Roy, a final
> year student from India, pursuing her B.Tech(I.T.) degree. Inspite of
> being in my final year this will be my first (probably the last too)
> attempt at GSoC. I was introduced to the wonderful world of FOSS by
> another FOSS enthusist who also successfully completed his GSoC
> project last year. Uptil then, my only interaction with FOSS was using
> the softwares but now I am looking into development aspects and want
> to contribute as well.
> I worked on an open-source project last year and created a
> GUI-cum-editor for VPython. As I did not interact with the core
> developers, my work could never be included in the VPython module. I
> learned this through GSoC, that communication is as important as
> contribution, and that the work you do is of no use if you just keep
> it to yourself.
> My skill-set includes working in languages C++,PHP and familiarity
> with PyGtk, Java, MySQL. I mostly work on Linux systems (Ubuntu and
> Fedora being my distros of choice) though I have a dual boot machine
> with Windows installed as well.
> The project which I would like to work on, under Linux Foundations is
> Integration of Geoclue with linux kernel and gnome-desktop. As
> suggested by Luis R. Rodriguez, who has agreed to comentor this
> project, it will be a combined project under both Linux Foundations
> and Gnome developers. Under the Gnome-desktop cover, I would work to
> include location-sensitivity functionality to various gnome
> applications like Tracker, Empathy, Gwibber, Evolution, Clock and use
> of OpenStreetMap and libchamplain library to display a map of the
> locality. The comments which I receive for the above proposal was that
> it was too short compared to GSoC and it only included submitting
> patches to a few gnome applications. Now since, the project will
> include providing Geoclue information to the Network Manager and
> currectly deducing the country based on the timezone provided by the
> user using Geoclue, I guess the project is big enough. Infact Geoclue
> does the automatic finding of the location (Geotargetting) based on IP
> address. It uses the database of hostip.info site for the same.
> I conversed about the merging of the two project ideas with Jussi
> Kukkonen, who is the major developer of Geoclue, and he expressed his
> views about it being a great idea but he said that geoclue cannot (in
> many cases) make guarantees on the correctness of results so using
> them for "regulatory compliance" should be done with understanding
> that. Example: wlan positioning is based on access point MAC address
> and the manufacturers are known to make mistakes with those, so there
> may be two devices out there with the same MAC address but totally
> different locations. If the afore-mentioned is acceptable then it is a
> great idea.

This is reasonable so long as the user gets some sort of pop-up to
tell them the country GeoClue has determined we want to set on the
GNOME desktop. If he clicks yes then its just as equal as what we have
now with iw or wpa_supplicant.

> I am planning to submit the project proposal under both
> Gnome as well as Linux Foundations, however if accepted under any, it
> will needed to be comentored by both the organisation's developers. I
> am working on the application and it should be ready within 1-2 days
> span. I am also looking forward to any comments/suggestions regarding
> the project.
> My contact details are as follows:
> email : kroykroy@gmail.com
> IM (XMPP) : kroykroy@gmail.com
> IRC nick : kr0y
> weblog : http://wannabe-a-geek.blogspot.com/
>
> Looking forward to hearing from you,

Sounds great, glad to know we have a student interested. We can
certainly split this GSoC up, I am up to help mentor the Linux
wireless part. I just do not know anything about GNOME so if we can
collaborate with Jussi to handle that it would be appreciated. We may
need some feedback from Dan Williams too, for example, on how he'd
like to see this become exposed to NM. Or from Marcel for Connman.

I suppose the first part will be the GNOME part, and the final piece
will be to inform applications somehow or let applications register
for this in some form of a multicast group. I don't speak userspace
though so beats me how this is accomplished nowadays.

  Luis
