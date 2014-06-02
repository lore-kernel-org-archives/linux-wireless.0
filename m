Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58086 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149AbaFBWLh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jun 2014 18:11:37 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1WraS6-0004qE-Jp
	for linux-wireless@vger.kernel.org; Tue, 03 Jun 2014 00:11:34 +0200
Received: from 89-68-80-14.dynamic.chello.pl ([89.68.80.14])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 03 Jun 2014 00:11:34 +0200
Received: from pitkotko by 89-68-80-14.dynamic.chello.pl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 03 Jun 2014 00:11:34 +0200
To: linux-wireless@vger.kernel.org
From: piotr <pitkotko@gmail.com>
Subject: Re: [Ilw] Wireless Centrino 2230-N issues
Date: Mon, 2 Jun 2014 22:11:22 +0000 (UTC)
Message-ID: <loom.20140603T000209-622@post.gmane.org> (sfid-20140603_001140_687156_7CD7478F)
References: <536F6620.9030001@gmail.com> <0BA3FCBA62E2DC44AF3030971E174FB303DF0FF6@HASMSX103.ger.corp.intel.com> <loom.20140530T020912-598@post.gmane.org> <53882EAD.4010609@gmail.com> <53882EF4.4070105@gmail.com> <loom.20140530T111920-677@post.gmane.org> <CANUX_P0JenW+GDT3N0Qj5BPGqMXqUWiBnj=TQ+nMEsjS4HFm1w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Emmanuel Grumbach <egrumbach@...> writes:

> 
> Can you please send the whole dmesg output?

[115535.469083] iwlwifi 0000:01:00.0: Could not complete ALIVE transition: -5
[115535.469370] iwlwifi 0000:01:00.0: Failed to run INIT ucode: -5
[115535.469412] iwlwifi 0000:01:00.0: Unable to initialize device.
[115535.471365] iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
[115535.478424] iwlwifi 0000:01:00.0: Radio type=0x2-0x0-0x0
[115535.525086] iwlwifi 0000:01:00.0: Command COEX_PRIORITY_TABLE_CMD
failed: FW Error

This repeats over and over again.


Piotr


> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@...
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 




