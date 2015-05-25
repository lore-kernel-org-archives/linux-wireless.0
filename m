Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0190.hostedemail.com ([216.40.44.190]:59846 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751448AbbEYRhd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 May 2015 13:37:33 -0400
Message-ID: <1432575448.2846.63.camel@perches.com> (sfid-20150525_193742_302651_20FD9E40)
Subject: Re: [PATCH] staging: r8712u: Fix kernel warning for improper call
 of del_timer_sync()
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Haggai Eran <haggai.eran@gmail.com>,
	devel@driverdev.osuosl.org,
	Sudip Mukherjee <sudip@vectorindia.org>,
	gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
	Stable <stable@vger.kernel.org>, netdev@vger.kernel.org,
	Arek Rusniak <arek.rusi@gmail.com>
Date: Mon, 25 May 2015 10:37:28 -0700
In-Reply-To: <20150525091737.GQ4150@mwanda>
References: <1432415812-1285-1-git-send-email-Larry.Finger@lwfinger.net>
	 <CAJ=9CzbPmo+f4zjY4CqQ7TsUENpwy+zHcpxeLTbAH0DAZSkqsQ@mail.gmail.com>
	 <556268BC.5050807@lwfinger.net> <20150525091737.GQ4150@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-05-25 at 12:17 +0300, Dan Carpenter wrote:
> These are special intern patches that
> dont' go through the normal review process.  The intern process is over
> this year.  The lack of normal review introduced a number of bugs this
> year.  I always complain to Greg about it and he says that I should join
> the intern mailing list if I care so much.

It'd be better if the approved patches from the intern list
(no idea what that is) were sent to lkml/devel@driverdev lists
for review before actually being applied.


