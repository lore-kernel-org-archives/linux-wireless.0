Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f220.google.com ([209.85.219.220]:58801 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933597Ab0DHWkE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 18:40:04 -0400
Received: by ewy20 with SMTP id 20so1169743ewy.1
        for <linux-wireless@vger.kernel.org>; Thu, 08 Apr 2010 15:40:01 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH 8/9] rt2x00: Add rt3090 support in rt2800 register initialization.
Date: Fri, 9 Apr 2010 00:39:54 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <1270763437-29526-1-git-send-email-gwingerde@gmail.com> <1270763437-29526-9-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1270763437-29526-9-git-send-email-gwingerde@gmail.com>
MIME-Version: 1.0
Message-Id: <201004090039.54576.IvDoorn@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-15"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 08 April 2010, Gertjan van Wingerde wrote:
> Add RT3090 specific register initializations to rt2x00, based on the latest
> Ralink rt3090 vendor driver.
> 
> Untested as I don't actually own an RT3090 based device, but given experiences
> on rt3070/rt3071 very hopeful that this will actually work..
> 
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
