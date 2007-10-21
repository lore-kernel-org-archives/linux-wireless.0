Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from serenity.mcc.ac.uk ([130.88.200.93]:59972 "EHLO
	serenity.mcc.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbXJUQOg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Oct 2007 12:14:36 -0400
Message-ID: <471B7B0C.5090900@gentoo.org> (sfid-20071021_171440_384572_0AB8E976)
Date: Sun, 21 Oct 2007 17:15:08 +0100
From: Daniel Drake <dsd@gentoo.org>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: kune@deine-taler.de, linux-wireless@vger.kernel.org
Subject: Re: reading/writing zd1211 eeprom
References: <200710211335.39373.mb@bu3sch.de>
In-Reply-To: <200710211335.39373.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> I'd like to read/modify the eeprom of my zd stick.
> Do you have software to do so? If not, any advice on how
> this has to be done? I'd write the necessary driver patches,
> if you just tell me how the eeprom is accessed.

Yep, zd1211memtool.

http://sourceforge.net/project/showfiles.php?group_id=129083&package_id=238745

Usual precautions apply: you could easily break your device, and this 
code isn't very widely tested (but it works for me).

Daniel
