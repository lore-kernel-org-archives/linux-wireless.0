Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:48412 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489Ab1EQLub convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 May 2011 07:50:31 -0400
Received: by qwk3 with SMTP id 3so193997qwk.19
        for <linux-wireless@vger.kernel.org>; Tue, 17 May 2011 04:50:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1305631218.4250.0.camel@maggie>
References: <BANLkTik2Sc9aWi_cHVvLJzGv3esey=wPag@mail.gmail.com>
	<1305631218.4250.0.camel@maggie>
Date: Tue, 17 May 2011 13:50:30 +0200
Message-ID: <BANLkTinP083x+cWD1qk1LQYYn=QL18uN9g@mail.gmail.com> (sfid-20110517_135034_875318_17903551)
Subject: Re: ssb: how did we get special reject bit for SSB rev 2.3?
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?Q?Michael_B=C3=BCsch?= <m@bues.ch>
Cc: b43-dev <b43-dev@lists.infradead.org>,
	linux-wireless@vger.kernel.org, Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 17 maja 2011 13:20 użytkownik Michael Büsch <m@bues.ch> napisał:
> On Tue, 2011-05-17 at 12:40 +0200, Rafał Miłecki wrote:
>> Does anyone know where did we get this from?
>
> Should be in the git history.

It's here since:
[SSB]: add Sonics Silicon Backplane bus support

Maybe bcm43xx does contain sth...

-- 
Rafał
