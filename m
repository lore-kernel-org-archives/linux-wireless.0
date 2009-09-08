Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:9662 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754107AbZIHOI2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Sep 2009 10:08:28 -0400
Received: by fg-out-1718.google.com with SMTP id 22so1018631fge.1
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2009 07:08:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090908134732.GA1936@darkstar>
References: <20090908134732.GA1936@darkstar>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Tue, 8 Sep 2009 16:08:06 +0200
Message-ID: <69e28c910909080708n5233a6cfue555bfce170eb145@mail.gmail.com>
Subject: Re: b43 dma error
To: Dave Young <hidave.darkstar@gmail.com>
Cc: mb@bu3sch.de, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Do you have the threaded-IRQ patches applied? Also, what card is this?
(BCM4312?) Try upgrading your firmare (use v478 or the new v5xx one).
