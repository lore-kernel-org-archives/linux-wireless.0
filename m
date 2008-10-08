Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cavan.codon.org.uk ([93.93.128.6]:44746 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbYJHT5n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2008 15:57:43 -0400
Date: Wed, 8 Oct 2008 20:57:40 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Piter PUNK <piterpk@terra.com.br>
Cc: linux-wireless@vger.kernel.org
Subject: Re: RTL8187B transmit problems
Message-ID: <20081008195740.GA2794@srcf.ucam.org> (sfid-20081008_215748_485037_823BA5C1)
References: <48E979B7.4040000@terra.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <48E979B7.4040000@terra.com.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Try reducing the bit rate - iwconfig wlan0 11M fixed, for example.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
