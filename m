Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:20862 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbYC2Ox5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Mar 2008 10:53:57 -0400
Received: by fg-out-1718.google.com with SMTP id l27so826602fgb.17
        for <linux-wireless@vger.kernel.org>; Sat, 29 Mar 2008 07:53:56 -0700 (PDT)
To: Bas Hulsken <bhulsken@hotmail.com>
Subject: Re: rt2500pci, infinite calls to rt2x00mc_configure_filter
Date: Sat, 29 Mar 2008 15:53:03 +0100
Cc: linux-wireless@vger.kernel.org
References: <1206801246.24689.19.camel@Bas>
In-Reply-To: <1206801246.24689.19.camel@Bas>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200803291553.03955.IvDoorn@gmail.com> (sfid-20080329_145400_727291_577C47AD)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> with the latest changes, I guess in particular the commit "rt2x00: Fix
> in _atomic() usage" changing the flags for rt2500pci results in infinite
> calls to the new "rt2x00mc_configure_filter" in rt2x00mac.c. I noticed
> this after applying the attached patch that I've been using to debug
> some hostapd problems. All it does is add some printk's, I don't think
> it can cause the problem, right? 

Oops...
I found the problem, patch coming will be released in a few minutes. :)

Ivo
