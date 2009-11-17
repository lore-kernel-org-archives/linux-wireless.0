Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vps.qorvus.com ([67.213.217.156]:37728 "EHLO vps.qorvus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753765AbZKQSt6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2009 13:49:58 -0500
Message-ID: <C32E4D5CD18647DE9A4F47C6EB1A94C2@qlaptop2>
Reply-To: "Tom Sharples" <tsharples@qorvus.com>
From: "Tom Sharples" <tsharples@qorvus.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"Michael Renzmann" <mrenzmann@madwifi-project.org>
Cc: <madwifi-users@lists.sourceforge.net>,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	<madwifi-devel@lists.sourceforge.net>
References: <2205.95.222.251.107.1258282369.squirrel@webmail.otaku42.de> <43e72e890911161701p61d0db5ag25a1459f900b3ab7@mail.gmail.com> <1803.194.45.26.221.1258473872.squirrel@webmail.madwifi-project.org> <43e72e890911170838g26172725ga4a843dc5292c29f@mail.gmail.com>
Subject: Re: [Madwifi-devel] Survey: What are you using MadWifi for, and why?
Date: Tue, 17 Nov 2009 09:51:48 -0800
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Comments inline:
>
> My point was that there are already hundreds of users already on ath5k
> and ath9k and that obviously you will get a biased view of MadWifi /
> ath5k situation (I don't consider MadWifi any type of alternative to
> ath9k).

We have way more users than this running just our version. There are 
probably tens of thousands of "users" (embedded systems) that run some 
flavor of madwifi.

>>
>> The development of any software should happen with the user's needs and
>> requirements in mind
>
> Note I didn't say otherwise.

Your comments, at best, give short shrift to the many, many embedded users, 
esp those who run the 2.4.x kernel. Does anyone actually think it would be 
practical to remotely upgrade tens of thousands of unattended devices, some 
of which are miles away from the nearest human, to a 2.6 kernel? Even if 
only 5% fail to come back online, it would be a logistical and 
customer-relations disaster. These aren't windows desktops where someone can 
just curse and then powercycle.

>
> Well to me they are clear and I don't need a survey to understand
> this. ath5k currently lacks:
>
>  * DFS
>  * Multi-BSS AP functionality
>  * Roaming
>  * ANI
>
 You also need to add to this list:

* Fast-frames
* Compression
* Half / quarter channels (hopefully done in a sensible fashion like AirOS 
without the countrycode / regdomain BS)

We need to aknowledge that "user" includes not just those surfing on their 
laptops, but the far larger number of embedded devices running madwifi each 
and every day, in critical systems, with excellent reliability.

Tom S.


