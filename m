Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:58582 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750991Ab1LJUeB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Dec 2011 15:34:01 -0500
Received: by laah2 with SMTP id h2so859715laa.31
        for <linux-wireless@vger.kernel.org>; Sat, 10 Dec 2011 12:33:58 -0800 (PST)
Subject: Re: modprobe utility not found
From: Luciano Coelho <coelho@ti.com>
To: PRASHANTH CHAKRAVARTHY <a19110@motorola.com>
Cc: linux-wireless@vger.kernel.org,
	Sireesha Kosuri <jmng34@motorola.com>
In-Reply-To: <CAPSXAjdTHKC7wxPXsS2VVNSJcgaWDTQSNBYQhfbog6--uHkDvg@mail.gmail.com>
References: <CAPSXAjdTHKC7wxPXsS2VVNSJcgaWDTQSNBYQhfbog6--uHkDvg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 10 Dec 2011 22:33:55 +0200
Message-ID: <1323549235.8996.336.camel@cumari> (sfid-20111210_213414_385810_D01EA2CF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-12-09 at 10:26 +0530, PRASHANTH CHAKRAVARTHY wrote: 
> Hi,
> We are trying to build compat utility on mac os machines. Builds are
> failing there with error /sbin/modprobe not found. They are passing on
> other linux machines .
> Is there a modprobe utility for mac os machines ?

I guess you're trying to run 'make install' in the Mac OS machine? That
doesn't make sense.  You should only install the compat modules on the
target machine (and I'm sure the target is not your Mac ;).

If you're cross-compiling your modules, you should copy them to the
target.  Or run the make install in the target (which would involve
copying more than just the compiled modules).

I hope this helps.

-- 
Cheers,
Luca.

