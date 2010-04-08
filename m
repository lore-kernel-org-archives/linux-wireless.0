Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:31823 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755829Ab0DHWRJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 18:17:09 -0400
Received: by ey-out-2122.google.com with SMTP id 9so409559eyd.5
        for <linux-wireless@vger.kernel.org>; Thu, 08 Apr 2010 15:17:07 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH 1/9] rt2x00: Let RF chipset decide the RF channel switch method to use in rt2800.
Date: Fri, 9 Apr 2010 00:17:04 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <1270763437-29526-1-git-send-email-gwingerde@gmail.com> <1270763437-29526-2-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1270763437-29526-2-git-send-email-gwingerde@gmail.com>
MIME-Version: 1.0
Message-Id: <201004090017.04465.IvDoorn@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-15"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 08 April 2010, Gertjan van Wingerde wrote:
> It seems that the distinction between RF channel switch method is solely based
> on the RF chipset that is used.
> Refactor the channel switch decision to just take the RF chipset into account,
> thereby greatly simplifying the check.
> 
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
