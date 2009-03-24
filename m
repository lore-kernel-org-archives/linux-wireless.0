Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.171]:25565 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333AbZCXXip (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 19:38:45 -0400
Received: by wf-out-1314.google.com with SMTP id 29so3692963wff.4
        for <linux-wireless@vger.kernel.org>; Tue, 24 Mar 2009 16:38:43 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 25 Mar 2009 05:08:28 +0530
Message-ID: <68f4d6130903241638q63937f8cwbb2969f7fc680b25@mail.gmail.com> (sfid-20090325_003848_311711_829F344E)
Subject: GSoC project abstract : Integrate Geoclue with Gnome-desktop and to
	help with regulatory compliance
From: k roy <kroykroy@gmail.com>
To: linux-wireless@vger.kernel.org, Luis Rodriguez <mcgrof@gmail.com>,
	geoclue@lists.freedesktop.org, Jussi Kukkonen <jku@linux.intel.com>
Cc: anand.shashwat@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I am including the project abstract which I will be submitting for
GSoC '09. I am developing the project application on the same lines.
Kindly correct me if I missed any important points/some technical
fallacies/the abstract isn't appealing enough.

Title : Integrate Geoclue with Gnome-desktop and to help with
regulatory compliance

Abstract :  Referring context information from the environment is what
humans do naturally, using their five senses. This context information
is extremely useful and it plays a major role in making humans smart.
Utilising the same context information will be extremely beneficial to
the computers as well and make them more user-friendly [1]. In today's
scenario a lot of automation and utility can be achieved utilising an
important context information i.e. location. If the computer can
automatically realise its location and can update its behaviour
accordingly, it can be indeed very useful. As the laptops are becoming
more and more mobile these days, location sensitivity is extremely
desired and necessary [2].

The current project aims to incorporate the location-awareness in the
Gnome-desktop and utilise the same to automatically update the linux
kernel to set the country for the current regulatory domain. The
geographical information will be treated along the same lines as time
and hence automatic updation or manual modification of the location
will be as easy as changing time or date. The functionalities which
the project intends to achieve are extremely desired and not provided
for, till now. With these functionalities, a user can can use her
location as the factor to automate some routine tasks [3]. For
example, if the geographical information is incorporated in the
Tracker so that it indexes the files based on location as well, a user
can query for the files which were modified/accessed in a particular
location (say office). The Clock applet can update its timezone and
weather settings after sensing the change in location. The similar
approach can be used in maintaining the new regulatory implementation
for Linux wireless by informing the kernel about the country the
system is in [4].

Location of a computer system can be estimated with the help of a
number of factors like GPS, IP Address, Mac Address, etc. GeoClue is a
D-Bus service which utilizes the information from these factors and
helps applications to become geo-aware [5]. The project will utilise
the set of geoinformation APIs provided by GeoClue, and the providers
which implement these APIs, to get position information, get location
coordinates through address and the reverse.

As the first step towards making the Gnome-desktop location aware, the
following Gnome applications will be integrated with GeoClue services
:  Clock and weather applet, Tracker, Evolution, Empathy and Gwibber.
Also, for the Internet-based applications, a map can be generated to
view the location of the contacts in the visual format, using
OpenStreetMap and libchamplain [6]. The next part of the project is to
provide the location information to linux kernel. This will be
implemented by to extending Network Manager to make use of the
information supplied by GeoClue to be able to seed to wpa_supplicant,
the country which should be set for the current regulatory domain,
which in turn passes the information to the kernel [7].

1.http://worrydream.com/MagicInk/#inferring_context_from_the_environment
2.http://arstechnica.com/hardware/news/2008/06/hands-on-with-the-ubuntu-netbook-remix.ars
3.http://docs.google.com/Present?docid=dd4m6zsj_5z2jbjqc9
4.http://wireless.kernel.org/en/developers/Regulatory
5.http://www.freedesktop.org/wiki/Software/GeoClue
6.http://blog.pierlux.com/2009/01/22/empathy-where-are-you/en/
7.http://wireless.kernel.org/en/developers/GSoC/2009/GeoClue_regulatory

Thanking you,
~kr0y.

-- 
~ Once you have flown, you will walk the earth with your eyes turned
skyward, for there you have been, there you long to return --Da Vinci
