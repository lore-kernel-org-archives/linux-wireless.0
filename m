Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:36372 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab0FYWji convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jun 2010 18:39:38 -0400
Received: by iwn41 with SMTP id 41so2467646iwn.19
        for <linux-wireless@vger.kernel.org>; Fri, 25 Jun 2010 15:39:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTimeR5kQX2hSNw0Ud0QOF0-nsqCFMkSNul9wwa7C@mail.gmail.com>
References: <AANLkTinHfFVr45OV3V6CT9auK3L-JfrCYUMQpeo9toTw@mail.gmail.com>
	<AANLkTimeR5kQX2hSNw0Ud0QOF0-nsqCFMkSNul9wwa7C@mail.gmail.com>
Date: Fri, 25 Jun 2010 19:39:37 -0300
Message-ID: <AANLkTinhl-J6kUCxdjjAFyAoXRcHAhum8asBPuhwiveF@mail.gmail.com>
Subject: Re: mesh configuration information element is wrong?
From: Iuri Diniz <iuridiniz@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 25, 2010 at 2:43 PM, Iuri Diniz <iuridiniz@gmail.com> wrote:
> I'm analyzing the 802.11s code and I think I've found that mesh
> configuration information element has wrongs sizes.
>
> It is not according to my copy of 802.11s draft 3.

It seems that (in the past) the code had that sizes I think right.

http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=blobdiff;f=net/mac80211/mesh.c;h=c8a4f19ed13bb810a97bb5e25200a74cdd55a31c;hp=79425182c2903a70f355f1bdb34fe9fe8239fe05;hb=10f8f42ece65ba964ca14e794e5f45ad98d56cf1;hpb=8f2fda9594f083981ad54c1994863875fe680925

so I'll assume that the last draft has changed the size of this IE.

But could someone with access to the last draft draft confirm it?

Sorry for annoying you guys, I don't have the last draft.

-- 
Iuri Diniz
http://iuridiniz.com [Sou um agitador, não um advogado]
http://blog.igdium.com [Linux on Limbo]
