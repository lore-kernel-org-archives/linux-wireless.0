Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f220.google.com ([209.85.219.220]:51711 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932955Ab0DHWdx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 18:33:53 -0400
Received: by mail-ew0-f220.google.com with SMTP id 20so1168751ewy.1
        for <linux-wireless@vger.kernel.org>; Thu, 08 Apr 2010 15:33:53 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH 4/9] rt2x00: Remove rt2800 version constants.
Date: Fri, 9 Apr 2010 00:32:53 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <1270763437-29526-1-git-send-email-gwingerde@gmail.com> <1270763437-29526-5-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1270763437-29526-5-git-send-email-gwingerde@gmail.com>
MIME-Version: 1.0
Message-Id: <201004090032.53842.IvDoorn@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-15"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 08 April 2010, Gertjan van Wingerde wrote:
> The rt2800 version constants are inconsistent, and the version number don't
> mean a lot of things anyway. Use the literal values in the code instead of
> some sort of fabricated version name macro.
> 
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Perhaps a more elegant way of using and defining needs to be found.
But at least the defined show what the purpose for the values is
rather then having magical values spread around the code.

Ivo
