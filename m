Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.190]:7372 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046AbXDMPZF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Apr 2007 11:25:05 -0400
Received: by mu-out-0910.google.com with SMTP id g7so961732muf
        for <linux-wireless@vger.kernel.org>; Fri, 13 Apr 2007 08:25:04 -0700 (PDT)
To: Michael Wu <flamingice@sourmilk.net>
Subject: Re: [PATCH] eeprom_93cx6: do not assume zeroed buffer
Date: Fri, 13 Apr 2007 17:24:01 +0200
Cc: John Linville <linville@tuxdriver.com>,
	Andrea Merello <andreamrl@tiscali.it>,
	linux-wireless@vger.kernel.org
References: <200704131017.22525.flamingice@sourmilk.net>
In-Reply-To: <200704131017.22525.flamingice@sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200704131724.02089.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 13 April 2007 16:17, Michael Wu wrote:
> eeprom_93cx6: do not assume zeroed buffer
> 
> From: Michael Wu <flamingice@sourmilk.net>
> 
> eeprom_93cx6_read_bits assumes u16 *data is already zeroed. This removes
> that assumption.

ACK. :)
This was indeed an issue where I was doubting if the driver should make sure the data
was set to zero or that the calling driver should be responsible.

Ivo
