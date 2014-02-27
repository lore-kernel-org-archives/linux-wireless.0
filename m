Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:35315 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107AbaB0Qpn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Feb 2014 11:45:43 -0500
Message-ID: <1393519539.4648.10.camel@jlt4.sipsolutions.net> (sfid-20140227_174546_434455_5994B45C)
Subject: Re: pci-half-mini 7260 Wireless AC support 3.13
From: Johannes Berg <johannes@sipsolutions.net>
To: Tim Nelson <tim.l.nelson@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 27 Feb 2014 17:45:39 +0100
In-Reply-To: <CAOAOC6Z5J8_-ZKVukxfz+_K402E5sjhTdBvf3TzsWUDgwqw0Zw@mail.gmail.com> (sfid-20140227_174126_861535_50372780)
References: <CAOAOC6a96e5MrEOVY=KXirhUU-rJRv2hgz5B0so9SkWYMpoDfw@mail.gmail.com>
	 <1393517094.4648.3.camel@jlt4.sipsolutions.net>
	 <CAOAOC6agHr6mVB2jcUx1qHWnBJZyOw0=KP0Wp5BVhrvJgRhmQg@mail.gmail.com>
	 <1393517627.4648.4.camel@jlt4.sipsolutions.net>
	 <CAOAOC6ZhnB=LrJWvG07tOK=b_wWAFO74YdhXWZPxrVCk8=425A@mail.gmail.com>
	 <CAOAOC6aoz43LdXBTcRHWqPMvQAVKsH6z4yNqe_hEpT7zouo+Ew@mail.gmail.com>
	 <1393519119.4648.7.camel@jlt4.sipsolutions.net>
	 <CAOAOC6Z5J8_-ZKVukxfz+_K402E5sjhTdBvf3TzsWUDgwqw0Zw@mail.gmail.com>
	 (sfid-20140227_174126_861535_50372780)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-02-27 at 11:41 -0500, Tim Nelson wrote:
> [    9.299536] iwlwifi 0000:02:00.0: Detected Intel(R) Dual Band
> Wireless AC 7260, REV=0x144

Hm ok that should support it. Maybe it's always connecting to the 2.4
GHz one for some reason? That seems unlikely but still possible...

Maybe you could get more dmesg data about the AP it selected, and the
wpa_supplicant log.

johannes

