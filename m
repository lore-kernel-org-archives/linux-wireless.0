Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:40207 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093AbZHBHqa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Aug 2009 03:46:30 -0400
Received: by ewy10 with SMTP id 10so2373696ewy.37
        for <linux-wireless@vger.kernel.org>; Sun, 02 Aug 2009 00:46:30 -0700 (PDT)
Message-ID: <4A754514.1080000@gmail.com>
Date: Sun, 02 Aug 2009 09:49:40 +0200
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] airo: Read buffer overflow
References: <4A753EDE.9030506@gmail.com>
In-Reply-To: <4A753EDE.9030506@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Op 02-08-09 09:23, Roel Kluin schreef:
> Check whether index is within bounds before testing the element.

Please ignore, I already sent this, sorry.
