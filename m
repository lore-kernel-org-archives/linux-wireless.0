Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.175]:5419 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756126AbYAJT0M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jan 2008 14:26:12 -0500
Received: by ug-out-1314.google.com with SMTP id z38so345652ugc.16
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jan 2008 11:26:11 -0800 (PST)
Message-ID: <47866FE6.4010100@gmail.com> (sfid-20080110_192630_077617_B3331316)
Date: Thu, 10 Jan 2008 20:20:06 +0100
From: Ronald <ronald645@gmail.com>
Reply-To: ronald645@gmail.com
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Bcm4311 shuts down on closing lid (intended?)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

The b43 driver in the linux kernel 2.6.24-rc7 works really good :) . 
Keep it up! However, one thing is bugging me: Why does the card stop 
sending/receiving packets when I close the lid? Is this behaviour 
intended in the new driver? If yes, can I disable it?

						Kind regards, Ronald

P.S. I have a broadcom 4311 with an unpatched kernel running Fedora 8
