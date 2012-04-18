Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:55974 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293Ab2DRIgS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2012 04:36:18 -0400
Received: by wibhq7 with SMTP id hq7so422192wib.1
        for <linux-wireless@vger.kernel.org>; Wed, 18 Apr 2012 01:36:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <0FC1AE2B-7E32-466B-AC33-F969F4E72B98@gmail.com>
References: <2F08FF0B-5C29-4827-AA5F-B0F3847D0B83@gmail.com>
	<4F8DC25E.9090702@broadcom.com>
	<B9AA983D-A169-497D-9C8E-BDBEF2348BB6@gmail.com>
	<4F8E0CBE.6010103@sipsolutions.net>
	<0FC1AE2B-7E32-466B-AC33-F969F4E72B98@gmail.com>
Date: Wed, 18 Apr 2012 11:36:16 +0300
Message-ID: <CANUX_P38YDFtL-KzKnFHd0+Ca29SUXoY+mGKaDUjConXaf3c9A@mail.gmail.com> (sfid-20120418_103623_291940_628A2696)
Subject: Re: wlan0 not present
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Dominik Feser <dominik.feser@googlemail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 18, 2012 at 09:49, Dominik Feser
<dominik.feser@googlemail.com> wrote:
>
> Hello Johannes,
>
> Can you be a bit more specific about your thoughts? What do you think is not working correctly?
> Am I understanding you correctly? You think I have a firmware problem?
>

Johannes says that you may be missing the fw file:

please send the output of:
lspci -s 02:00 -n

and then I will tell you what fw you need
