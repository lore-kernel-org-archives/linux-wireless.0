Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:55194 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757489Ab1CCPpM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2011 10:45:12 -0500
Received: by mail-wy0-f182.google.com with SMTP id 32so1354744wyb.13
        for <linux-wireless@vger.kernel.org>; Thu, 03 Mar 2011 07:45:05 -0800 (PST)
Subject: Re: [PATCH] wl12xx: Correctly set up protection if non-GF STAs are
 present
From: Luciano Coelho <coelho@ti.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1299059206-3919-1-git-send-email-helmut.schaa@googlemail.com>
References: <1299059206-3919-1-git-send-email-helmut.schaa@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Mar 2011 17:45:09 +0200
Message-ID: <1299167109.7039.9.camel@cumari>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-03-02 at 10:46 +0100, Helmut Schaa wrote:
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
> ---

This is good, thanks Helmut! We had some problems with earlier versions
of our firmware where this was apparently not implemented, that's why we
were setting it always to 0.

I added a description to your commit, hope you don't mind.

Applied!

-- 
Cheers,
Luca.

