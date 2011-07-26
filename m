Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52174 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753696Ab1GZP4F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jul 2011 11:56:05 -0400
Received: by iyb12 with SMTP id 12so669718iyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jul 2011 08:56:02 -0700 (PDT)
Message-ID: <4E2EE383.4040403@lwfinger.net> (sfid-20110726_175611_040788_6D7D47A5)
Date: Tue, 26 Jul 2011 10:55:47 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 2/2] b43legacy: remove asm/atomic.h includes as suggested
 by checkpatch.pl
References: <20110726153648.24611.49190.stgit@mj.roinet.com> <20110726153655.24611.76833.stgit@mj.roinet.com>
In-Reply-To: <20110726153655.24611.76833.stgit@mj.roinet.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/26/2011 10:36 AM, Pavel Roskin wrote:
> Including linux/atomic.h doesn't appear to be necessary.
>
> Signed-off-by: Pavel Roskin<proski@gnu.org>

As b43 manages to also do atomic operations without this header, this patch 
should be OK for all architectures.

ACKed-by: Larry Finger <Larry.Finger@lwfinger.net>

