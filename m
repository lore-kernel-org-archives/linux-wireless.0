Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emita2.mittwald.de ([85.199.184.189]:51448 "EHLO
	emita2.mittwald.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755081Ab0FVIzI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jun 2010 04:55:08 -0400
Received: from mx51.mymxserver.com (mail5101.internal [172.16.51.1])
	by emita2.mittwald.de (Postfix) with ESMTP id E79591F9160
	for <linux-wireless@vger.kernel.org>; Tue, 22 Jun 2010 10:55:06 +0200 (CEST)
From: Holger Schurig <holgerschurig@gmail.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: wireless-regdb: Add A band in IL - And general point regarding tx power limits in the dbase
Date: Tue, 22 Jun 2010 10:52:34 +0200
References: <1274856569-13436-1-git-send-email-emmanuel.grumbach@intel.com> <93781E992CBA7843962D8B0E7D683F3C1172BD0B6D@SC1EXMB-MBCL.global.atheros.com> <AANLkTinGczUb2xTX5RUtnrRnc2BitOjZnpkDeHPV9Hwf@mail.gmail.com>
In-Reply-To: <AANLkTinGczUb2xTX5RUtnrRnc2BitOjZnpkDeHPV9Hwf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201006221052.34484.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Can you please help me translation from mW to db ?

You cannot.

"dB" is without a reference. Is only a relative measurement. You can, however, 
convert "dB" into some factor.

What we were talking about was "dBm". Here we use a reference point of one 
milliwatt. Now you can convert dBm to milliwatt.

Another example of a "made absolute by using a reference" logarithmic scale is 
the gain of antennas. It's usually described in dBi or dBd. The first takes 
the (hypothetical) isotropical antenna, the second an dipol as reference.



For more info, search for "dBm" in http://en.wikipedia.org/wiki/Decibel

-- 
DH3HS, http://www.holgerschurig.de
