Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0242.hostedemail.com ([216.40.44.242]:34781 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751736AbbC1TxA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Mar 2015 15:53:00 -0400
Message-ID: <1427572374.2715.2.camel@perches.com> (sfid-20150328_205330_582888_85E9E6E7)
Subject: Re: [PATCH v4 00/15] checkpatch clean-up of rtl8723au's
 rtw_security.c
From: Joe Perches <joe@perches.com>
To: "M. Vefa Bicakci" <m.v.b@runbox.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	gregkh@linuxfoundation.org, Jes.Sorensen@redhat.com,
	Larry.Finger@lwfinger.net, mail@beyermatthias.de
Date: Sat, 28 Mar 2015 12:52:54 -0700
In-Reply-To: <1427547168-12078-1-git-send-email-m.v.b@runbox.com>
References: <1427547168-12078-1-git-send-email-m.v.b@runbox.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2015-03-28 at 08:52 -0400, M. Vefa Bicakci wrote:
> These commits address a number of checkpatch.pl warnings and errors
> in rtl8723au's rtw_security.c.

Hello.

This is one of those patchsets that should be
done against Greg's staging-testing branch.

There are some commits against rtl8723au in that
branch that will conflict with your patches.


