Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36295 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086Ab2DRIsu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2012 04:48:50 -0400
Received: by bkcik5 with SMTP id ik5so5236102bkc.19
        for <linux-wireless@vger.kernel.org>; Wed, 18 Apr 2012 01:48:49 -0700 (PDT)
Subject: Re: wlan0 not present
Mime-Version: 1.0 (Apple Message framework v1257)
Content-Type: text/plain; charset=US-ASCII
From: Dominik Feser <dominik.feser@googlemail.com>
In-Reply-To: <CANUX_P38YDFtL-KzKnFHd0+Ca29SUXoY+mGKaDUjConXaf3c9A@mail.gmail.com>
Date: Wed, 18 Apr 2012 10:48:45 +0200
Cc: Dominik Feser <dominik.feser@googlemail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Message-Id: <4B048FDE-C784-4401-9FEC-16F8CC0B8D59@gmail.com> (sfid-20120418_104854_395944_708B9EFE)
References: <2F08FF0B-5C29-4827-AA5F-B0F3847D0B83@gmail.com> <4F8DC25E.9090702@broadcom.com> <B9AA983D-A169-497D-9C8E-BDBEF2348BB6@gmail.com> <4F8E0CBE.6010103@sipsolutions.net> <0FC1AE2B-7E32-466B-AC33-F969F4E72B98@gmail.com> <CANUX_P38YDFtL-KzKnFHd0+Ca29SUXoY+mGKaDUjConXaf3c9A@mail.gmail.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Emmanuel,

here is the output:
# lspci -s 02:00 -n
02:00.0 0280: 8086:0082 (rev 34)

THX,
Dominik

Am 18.04.2012 um 10:36 schrieb Emmanuel Grumbach:

> On Wed, Apr 18, 2012 at 09:49, Dominik Feser
> <dominik.feser@googlemail.com> wrote:
>> 
>> Hello Johannes,
>> 
>> Can you be a bit more specific about your thoughts? What do you think is not working correctly?
>> Am I understanding you correctly? You think I have a firmware problem?
>> 
> 
> Johannes says that you may be missing the fw file:
> 
> please send the output of:
> lspci -s 02:00 -n
> 
> and then I will tell you what fw you need

