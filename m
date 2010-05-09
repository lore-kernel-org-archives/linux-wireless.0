Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:34512 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722Ab0EIJSe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 May 2010 05:18:34 -0400
Subject: Re: [PATCH 1/9] rt2x00: Fix setting of txdesc->length field.
From: Pavel Roskin <proski@gnu.org>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
In-Reply-To: <AANLkTikWtLvG-J9UclCEsp7V1B7_J69eujVseWVsZk2y@mail.gmail.com>
References: <1273354826-4335-1-git-send-email-gwingerde@gmail.com>
	 <1273354826-4335-2-git-send-email-gwingerde@gmail.com>
	 <AANLkTikWtLvG-J9UclCEsp7V1B7_J69eujVseWVsZk2y@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 09 May 2010 05:18:29 -0400
Message-Id: <1273396709.11380.0.camel@ct>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2010-05-09 at 11:03 +0200, Ivo Van Doorn wrote:
> On Sat, May 8, 2010 at 11:40 PM, Gertjan van Wingerde
> <gwingerde@gmail.com> wrote:
> > We should take the stripping of the IV into account for the txdesc->length
> > field.
> >
> > Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
> 
> Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

Tested-by: Pavel Roskin <proski@gnu.org>

It's working.  Thank you!

-- 
Regards,
Pavel Roskin
