Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:23812 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbYHKRts (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Aug 2008 13:49:48 -0400
Received: by nf-out-0910.google.com with SMTP id d3so712009nfc.21
        for <linux-wireless@vger.kernel.org>; Mon, 11 Aug 2008 10:49:46 -0700 (PDT)
To: Jan Willies <jan@willies.info>
Subject: Re: unable to associate with WPA-AP - rt2x00-2.1.8
Date: Mon, 11 Aug 2008 20:17:58 +0200
Cc: linux-wireless@vger.kernel.org
References: <489FF6A8.9030204@willies.info>
In-Reply-To: <489FF6A8.9030204@willies.info>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200808112017.58980.IvDoorn@gmail.com> (sfid-20080811_194951_877189_3328D882)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 11 August 2008, Jan Willies wrote:
> Hello,
> 
> I'm using Fedore9 and since the last update I cannot associate my rt2500pci card anymore, it's running into a timeout. I'm not seeing any log entries on the AP.
> 
> rt2500pci is version 2.1.8

I think this should have been fixed by patch:
http://lkml.org/lkml/2008/7/31/35

But I don't know if John has merged that patch to FC9 yet.

Ivo
