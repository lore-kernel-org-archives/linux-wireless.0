Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:19823 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755256AbYCaUmO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Mar 2008 16:42:14 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: problem with iwl4965 and kernel 2.6.24.4
Date: Mon, 31 Mar 2008 13:40:12 -0700
Message-ID: <D936D925018D154694D8A362EEB08920040FA1C9@orsmsx416.amr.corp.intel.com> (sfid-20080331_214219_978883_B111669C)
In-Reply-To: <183c1cc10803301935p16647709u837f3fb3377c687d@mail.gmail.com>
References: <183c1cc10803261031p6e7e16bdme000416095de9b7f@mail.gmail.com> <D936D925018D154694D8A362EEB0892004073B0C@orsmsx416.amr.corp.intel.com> <183c1cc10803261149r2f518772j2ea3a1b5df55b2cc@mail.gmail.com> <D936D925018D154694D8A362EEB0892004073D90@orsmsx416.amr.corp.intel.com> <183c1cc10803262027k4c40386v767b2f9c79945deb@mail.gmail.com> <183c1cc10803270741r66896d88q15614af05a4142e6@mail.gmail.com> <D936D925018D154694D8A362EEB08920040BC0B8@orsmsx416.amr.corp.intel.com> <183c1cc10803301935p16647709u837f3fb3377c687d@mail.gmail.com>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "John Goulah" <jgoulah@gmail.com>, <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday, March 30, 2008 7:35 PM, John Goulah  wrote:

> Let me know where to go from here; if you still want the
> wpa_supplicant info I can post a bug for that, but the more major
> problem seems that I have to explicitly tell iwconfig what my AP mac
> address is, it wont associate otherwise even though "iwlist scan"
> turns it up just fine, but I'm not having much luck producing useful
> info here. 

It is not clear how you are associating. Are you using wpa_supplicant or
iwconfig? Please submit a bug with the details of your setup and steps
to associate. Please include the wpa_supplicant logs and the driver
logs.

Thanks

Reinette
