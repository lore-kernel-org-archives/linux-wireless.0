Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f173.google.com ([209.85.220.173]:33514 "EHLO
	mail-qk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934504AbbLQLnN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Dec 2015 06:43:13 -0500
Received: by mail-qk0-f173.google.com with SMTP id k189so97424926qkc.0
        for <linux-wireless@vger.kernel.org>; Thu, 17 Dec 2015 03:43:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1450350106.3430.5.camel@perches.com>
References: <1450302215-16156-1-git-send-email-ola1olsson@gmail.com>
	<1450314972.5661.2.camel@perches.com>
	<CABAco3BSaB9R6-nZQsmOnfXXy2ra-un0jjeBkyq4inzCybD5dw@mail.gmail.com>
	<1450329559.5661.5.camel@perches.com>
	<CABAco3DCSqzrCZWYXyibV0U1vuTk1En0k505J67vT6eEP2SfEw@mail.gmail.com>
	<1450339048.8247.19.camel@sipsolutions.net>
	<1450350106.3430.5.camel@perches.com>
Date: Thu, 17 Dec 2015 12:43:12 +0100
Message-ID: <CABAco3ACmC4R0S2n6xZQqW4BT3OiVisZAhwF_di0ohPYa5Vr8A@mail.gmail.com> (sfid-20151217_124322_417771_71A2BBF7)
Subject: Re: [PATCH] Print warnings for missing cfg80211_ops implementations
From: Ola Olsson <ola1olsson@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"ola. olsson" <ola.olsson@sonymobile.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Using
>         WARN_ON(!a ^ !b)
> which is logically the same as what I wrote above
> for clarity is simply a bit more coverage and maybe
> even a bit run-time faster.
>
>
Didn't think about that. Love your bit fiddling trick! After an
approval/rejection of my patch I can submit another one with your
suggestion unless you want to do it yourself...

/Ola
