Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:58944 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754908Ab2GJMVV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2012 08:21:21 -0400
Received: by yhmm54 with SMTP id m54so411123yhm.19
        for <linux-wireless@vger.kernel.org>; Tue, 10 Jul 2012 05:21:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6UF57isp+z4j3c0JNyTKHKfUsbU1UhMYKbZdGfEaeLn3w@mail.gmail.com>
References: <1341845663-24539-1-git-send-email-ozancag@gmail.com>
	<CAB=NE6UF57isp+z4j3c0JNyTKHKfUsbU1UhMYKbZdGfEaeLn3w@mail.gmail.com>
Date: Tue, 10 Jul 2012 15:21:20 +0300
Message-ID: <CAFub=KREsMQiY7Qo6e+KMFgzLvD7dQ5KJNKASOb3eiQL9uSFXw@mail.gmail.com> (sfid-20120710_142125_127373_6BEA8C98)
Subject: Re: [RFC] compat: Add ability to run as non-root
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozancag@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Cc: linux-wireless@vger.kernel.org, mcgrof@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
>> or ckmake with 'sudo'.
>
> How about instead having ckmake detect first if you have your
> $HOME/ksrc/ and if so use that, otherwise go with the built in stuff ?

This way, if you do not have $HOME/ksrc (which is the case when you
first run get-compat-kernels on a clean system), you will fallback to
the case where the script downloads and extracts the debs into
/usr/src which will again make sure that you will not have $HOME/ksrc
in the next run. How will we populate $HOME/ksrc?
