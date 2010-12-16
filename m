Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web56806.mail.re3.yahoo.com ([66.196.97.80]:31974 "HELO
	web56806.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751449Ab0LPNEc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Dec 2010 08:04:32 -0500
Message-ID: <370262.79515.qm@web56806.mail.re3.yahoo.com>
Date: Thu, 16 Dec 2010 05:04:30 -0800 (PST)
From: Walter Goldens <goldenstranger@yahoo.com>
Subject: Re: [PATCH 04/17] rt2x00: fix hang when unplugging USB device in use
To: Ivo Van Doorn <ivdoorn@gmail.com>
Cc: js@sig21.net, linux-wireless@vger.kernel.org,
	users@rt2x00.serialmonkey.com
In-Reply-To: <599567.31181.qm@web56805.mail.re3.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Even with the latest patches, rmmod'ing the rt2xXXX stuff causes a complete system freeze. Unless I bring down the interface first via 'ifconfig wlanX down', unloading the driver while operational equates OS hang and hard reset.

Walter.


      
