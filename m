Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f220.google.com ([209.85.219.220]:58530 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953Ab0DKQzo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Apr 2010 12:55:44 -0400
Received: by ewy20 with SMTP id 20so1707665ewy.1
        for <linux-wireless@vger.kernel.org>; Sun, 11 Apr 2010 09:55:42 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH 4/9] rt2x00: Refactor rt2800 version constants.
Date: Sun, 11 Apr 2010 18:55:40 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <1270989075-2267-1-git-send-email-gwingerde@gmail.com> <1270989075-2267-5-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1270989075-2267-5-git-send-email-gwingerde@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <201004111855.40831.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 11 April 2010, Gertjan van Wingerde wrote:
> The rt2800 version constants are inconsistent, and the version number don't
> mean a lot of things anyway. Refactor the constants to have some more
> meaningful names, and introduce and use some new helpers to check these
> chipset revisions. At the same time rename to revision, as they are more
> revision numbers rather than version numbers.
> 
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

