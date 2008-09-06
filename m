Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:51425 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752821AbYIFW5h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Sep 2008 18:57:37 -0400
Message-ID: <48C30ADF.6010708@lwfinger.net> (sfid-20080907_005800_845299_1073CD74)
Date: Sat, 06 Sep 2008 17:57:35 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>,
	Pavel Roskin <proski@gnu.org>, Tomas Winkler <tomasw@gmail.com>
Subject: Re: [PATCH v2] p54usb: support LM87 firmwares
References: <200809022139.12969.chunkeey@web.de> <200809030200.50745.chunkeey@web.de> <1220492662.7700.21.camel@dv> <200809041229.38538.chunkeey@web.de>
In-Reply-To: <200809041229.38538.chunkeey@web.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> This patch adds the necessary changes to support LM87 firmwares.
> 

Do you have a URL for the LM87 firmware? After this patch was added, I 
tried the 2.5.11.0.arm and 2.13.1.0.arm files, but only the old 
2.5.8.0 works. That is the one with the 'ping -s 1400' problem.

Larry

