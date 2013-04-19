Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:39835 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964912Ab3DSX2W (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Apr 2013 19:28:22 -0400
Message-ID: <1366414100.3901.71.camel@joe-AO722> (sfid-20130420_012826_229697_46BCD105)
Subject: Re: [PATCH] Fix uninitialized-variable warnings.
From: Joe Perches <joe@perches.com>
To: Han =?UTF-8?Q?Shen=28=E6=B2=88=E6=B6=B5=29?= <shenhan@google.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, chaoming_li@realsil.com.cn
Date: Fri, 19 Apr 2013 16:28:20 -0700
In-Reply-To: <CACkGtrg9bUFTQOMCK671a26A=tznMHrswQc8qDSMAcB29xy-xA@mail.gmail.com>
References: <1365703360-19982-1-git-send-email-shenhan@google.com>
	 <1365705330.1929.30.camel@joe-AO722> <51671663.3070707@lwfinger.net>
	 <CACkGtri5R2sgFZd9-M+UCNJ1NOwFS769NJqHUTgWUgtgRnDWow@mail.gmail.com>
	 <CACkGtrg9bUFTQOMCK671a26A=tznMHrswQc8qDSMAcB29xy-xA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-04-19 at 13:43 -0700, Han Shen(沈涵) wrote:
> I've prepared below (simple) patch just adding
> initialization list and what Joe's patch does.
> 
> Is this ok?

No.  It's whitespace damaged.

Try to make sure your patch applies
by first sending it to yourself and
then check to see if git am accepts it
without warnings or errors.

