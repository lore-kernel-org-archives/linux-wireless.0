Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:43972 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753940AbZLWIQj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Dec 2009 03:16:39 -0500
Received: by ey-out-2122.google.com with SMTP id 25so426882eya.19
        for <linux-wireless@vger.kernel.org>; Wed, 23 Dec 2009 00:16:37 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH 5/5] rt2x00: Cleanup chip handling helper functions.
Date: Wed, 23 Dec 2009 09:16:35 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <1261523005-5856-1-git-send-email-gwingerde@gmail.com> <1261523005-5856-5-git-send-email-gwingerde@gmail.com> <1261523005-5856-6-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1261523005-5856-6-git-send-email-gwingerde@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200912230916.35643.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 23 December 2009, Gertjan van Wingerde wrote:
> Let each of them take a struct rt2x00_dev pointer as argument instead of
> a mixture of struct rt2x00_chip and struct rt2x00_dev pointers.
> Preparation for further clean ups in the rt2x00 chip handling, especially
> for rt2800 devices.
> 
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

