Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:51711 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120AbaDDQOJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Apr 2014 12:14:09 -0400
Received: by mail-wg0-f51.google.com with SMTP id k14so3756073wgh.10
        for <linux-wireless@vger.kernel.org>; Fri, 04 Apr 2014 09:14:08 -0700 (PDT)
Message-ID: <533EDA4E.9020308@gmail.com> (sfid-20140404_181415_231460_5210AF7F)
Date: Fri, 04 Apr 2014 18:14:06 +0200
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: fariyaf@gmail.com, linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Fwd: Submission of firmware for driver RSI
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fariya wrote:

> I would like to submit the RSI firmware to the linux-firmware git. Can
> anyone point me to the procedure for f/w submission? Can I submit the
> f/w onto this mailing list?

https://git.kernel.org/cgit/linux/kernel/git/firmware/linux-firmware.git/plain/README
is your friend:

--cut--

	Linux firmware
	==============

  <http://git.kernel.org/?p=linux/kernel/git/firmware/linux-firmware.git>

  git://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git

This repository contains all these firmware images which have been
extracted from older drivers, as well various new firmware images which
we were never permitted to include in a GPL'd work, but which we _have_
been permitted to redistribute under separate cover.

To submit firmware to this repository, please send either a git binary
diff or preferably a git pull request to:
      David Woodhouse <dwmw2@infradead.org>
      Ben Hutchings <ben@decadent.org.uk>
and also cc: to related mailing lists.

Your commit should include an update to the WHENCE file clearly
identifying the licence under which the firmware is available, and
that it is redistributable. If the licence is long and involved, it's
permitted to include it in a separate file and refer to it from the
WHENCE file.
And if it were possible, a changelog of the firmware itself.

Ideally, your commit should contain a Signed-Off-By: from someone
authoritative on the licensing of the firmware in question (i.e. from
within the company that owns the code).


WARNING:
=======

Don't send any "CONFIDENTIALITY STATEMENT" in your e-mail, patch or
request. Otherwise your firmware _will never be accepted_.

Maintainers are really busy, so don't expect a prompt reply.
--theend--
