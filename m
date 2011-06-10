Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41910 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757770Ab1FJSmg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jun 2011 14:42:36 -0400
Received: by bwz15 with SMTP id 15so2412663bwz.19
        for <linux-wireless@vger.kernel.org>; Fri, 10 Jun 2011 11:42:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTimjLdr2Qb+yfUx84p4k2Oq8iumDhg@mail.gmail.com>
References: <201105251813.36804.stevie.trujillo@gmail.com> <1306352560.20732.0.camel@wwguy-ubuntu>
 <201105252154.06204.stevie.trujillo@gmail.com> <1306376938.20732.2.camel@wwguy-ubuntu>
 <4DDE1458.9090004@t-online.de> <1306419109.20732.6.camel@wwguy-ubuntu>
 <4DF246D1.9000107@t-online.de> <1307727083.13397.57.camel@wwguy-huron>
 <4DF26175.2010506@t-online.de> <BANLkTimjLdr2Qb+yfUx84p4k2Oq8iumDhg@mail.gmail.com>
From: Daniel Halperin <dhalperi@cs.washington.edu>
Date: Fri, 10 Jun 2011 11:42:07 -0700
Message-ID: <BANLkTimwn=sXSofPdQGg49Wsn6CxUbrOyw@mail.gmail.com> (sfid-20110610_204240_049096_1EB838AC)
Subject: Fwd: iwlagn: is tx_power_device_lmt a regulatory limit or a hardware limit?
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PSA: it's 2011, not 1971. The plaintext filter on l-w is stupid. If
its main goal is to ensure that patches come through correctly, it
doesn't help that much. Independent of plaintext, people still have to
jump through hoops to make sure the line wrapping comes through okay.

See below mail.

---------- Forwarded message ----------
From: Daniel Halperin <dhalperi@cs.washington.edu>
Date: Fri, Jun 10, 2011 at 11:37 AM
Subject: Re: iwlagn: is tx_power_device_lmt a regulatory limit or a
hardware limit?
To: Richard Schütz <r.schtz@t-online.de>
Cc: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>, Stevie Trujillo
<stevie.trujillo@gmail.com>, "linux-wireless@vger.kernel.org"
<linux-wireless@vger.kernel.org>


On Fri, Jun 10, 2011 at 11:24 AM, Richard Schütz <r.schtz@t-online.de> wrote:
>
> According to [1] there are no countries that forbid tx power values lower than 20dBm in the 2.4 GHz band. The lowest value for the 5 GHz band listed is 17 dBm. So why are the Intel cards limited to 15dBm then for both bands? This value absolutely makes no sense in my view.
>
> [1] http://git.kernel.org/?p=linux/kernel/git/linville/wireless-regdb.git;a=blob;f=db.txt;hb=HEAD
>

Are you forgetting to account for the 3 dBi--7 dBi antenna gain?
Dan
