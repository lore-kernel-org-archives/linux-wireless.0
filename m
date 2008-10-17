Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.187]:4571 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754391AbYJQT1O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Oct 2008 15:27:14 -0400
Received: by nf-out-0910.google.com with SMTP id d3so408010nfc.21
        for <linux-wireless@vger.kernel.org>; Fri, 17 Oct 2008 12:27:08 -0700 (PDT)
To: John Daiker <daikerjohn@gmail.com>
Subject: Re: [PATCH] rt2x00: reduce checkpatch.pl errors
Date: Fri, 17 Oct 2008 21:27:03 +0200
Cc: rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <48F8E481.7000308@gmail.com>
In-Reply-To: <48F8E481.7000308@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200810172127.04168.IvDoorn@gmail.com> (sfid-20081017_212718_131375_ECF45B1C)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 17 October 2008, John Daiker wrote:
> A few changes to reduce checkpatch.pl errors in the rt2x00 driver.  For 
> the most part, I only fixed cosmetic things, and left the actual 'code 
> flow' untouched (hopefully)!
> 
> Diff is against wireless-testing HEAD.

Looks good. Thanks.

John could you merge this into wireless-testing? :)

> Signed-off-by: John Daiker <daikerjohn@gmail.com>

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
