Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:23283 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753333AbYFZVNJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jun 2008 17:13:09 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: commit 5dc4dfd6165883b6629a48256dc4eadf76d6b65d
Date: Thu, 26 Jun 2008 14:13:06 -0700
Message-ID: <BD524EA7912ED5469DFD0BAEF6BC752F03DC568A@orsmsx411.amr.corp.intel.com> (sfid-20080626_231314_644711_4A189EC9)
In-Reply-To: <f6ca9fed0806261411y1b8bca21k66da3a5090524bc6@mail.gmail.com>
References: <12145132373377-git-send-email-abhijeet.kolekar@intel.com> <200806262259.21764.IvDoorn@gmail.com> <f6ca9fed0806261411y1b8bca21k66da3a5090524bc6@mail.gmail.com>
From: "Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>
To: "drago01" <drago01@gmail.com>, "Ivo van Doorn" <ivdoorn@gmail.com>
Cc: <linux-wireless@vger.kernel.org>, <linville@tuxdriver.com>,
	<adel.gadllah@gmail.com>, "Zhu, Yi" <yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



-----Original Message-----
From: drago01 [mailto:drago01@gmail.com] 
Sent: Thursday, June 26, 2008 2:12 PM
To: Ivo van Doorn
Cc: Kolekar, Abhijeet; linux-wireless@vger.kernel.org;
linville@tuxdriver.com; adel.gadllah@gmail.com; Zhu, Yi
Subject: Re: commit 5dc4dfd6165883b6629a48256dc4eadf76d6b65d

On Thu, Jun 26, 2008 at 10:59 PM, Ivo van Doorn <ivdoorn@gmail.com>
wrote:
> On Thursday 26 June 2008, Abhijeet Kolekar wrote:
>>     iwlwifi : Patch adds rfkill subsystem for 3945
>>
>>     The patch removes the sysfs interface from iwl3945 and uses
>>     the rfkill subsystem instead.
>
> Shouldn't the driver depend on CONFIG_RFKILL?
> Otherwise compilation will fail when CONFIG_RFKILL isn't selected...

"[PATCH -next] iwlwifi: fix build for CONFIG_INPUT=n" adresses part of
this.

IWLWIFI_RFKILL depends on IWLCORE but iwl3945 does not use iwlcore
module.
Should we just add a IWL3945_RFKILL and add he changes from the
mentioned patch to 3945 too?

If its ok I can send a patch.

That will be great!!
