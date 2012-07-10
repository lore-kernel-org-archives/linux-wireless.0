Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:56694 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755376Ab2GJMQb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2012 08:16:31 -0400
Received: by ghrr11 with SMTP id r11so11163583ghr.19
        for <linux-wireless@vger.kernel.org>; Tue, 10 Jul 2012 05:16:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFub=KTDYF71=GiEMAdVNDTKeMMZYFy4C0YqPpvhOE-+MShrKQ@mail.gmail.com>
References: <1341834481-1831-1-git-send-email-ozancag@gmail.com>
	<CAFub=KTDYF71=GiEMAdVNDTKeMMZYFy4C0YqPpvhOE-+MShrKQ@mail.gmail.com>
Date: Tue, 10 Jul 2012 15:16:30 +0300
Message-ID: <CAFub=KTPnR4Ydyt9hNhEzAN4HFe0ZN7m4W3cYGtiAy5KLYCZEg@mail.gmail.com> (sfid-20120710_141724_261889_FC14044F)
Subject: Re: [PATCH] compat: Fix setting $TARGET
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozancag@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 10, 2012 at 1:11 PM, Ozan Çağlayan <ozancag@gmail.com> wrote:
> On Mon, Jul 9, 2012 at 2:48 PM, Ozan Çağlayan <ozancag@gmail.com> wrote:
>> commit 61077651424add644401b927b52681a191bbd7f1 moved the list of
>> kernels above which broke the $TARGET substitutions in them.
>>
>> Move the TARGET detection above of everything to fix this.
>>

Well if you apply my today's commit which dynamically generates ARCH
dependent deb names when downloading, you do not need to apply this
since wget is called after setting TARGET in get_ubuntu_kernels().




-- 
Ozan Çağlayan
