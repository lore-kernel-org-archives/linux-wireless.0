Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:38197 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbYDASIp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2008 14:08:45 -0400
Received: by nf-out-0910.google.com with SMTP id g13so923962nfb.21
        for <linux-wireless@vger.kernel.org>; Tue, 01 Apr 2008 11:08:43 -0700 (PDT)
To: Thomas =?iso-8859-15?q?B=E4chler?= <thomas@archlinux.org>
Subject: Re: RaLink RT2500 802.11g Cardbus/mini-PCI
Date: Tue, 1 Apr 2008 20:09:02 +0200
Cc: linux-wireless@vger.kernel.org
References: <35856.201.36.161.238.1206999707.squirrel@mamao.cetuc.puc-rio.br> <200804010010.15705.IvDoorn@gmail.com> <fstta0$jhu$1@ger.gmane.org>
In-Reply-To: <fstta0$jhu$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200804012009.02448.IvDoorn@gmail.com> (sfid-20080401_190848_765757_73AACEBC)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> >> Is the last kernel code working with RaLink RT2500 802.11g Cardbus/mini-PCI?
> > 
> > With 'latest' do you mean:
> >  latest 2.6.25-rc kernel?
> >  latest wireless-testing git snapshot
> >  latest rt2x00 git snapshot
> > 
> > The latter 2 should work fine, the first one has known issues
> > but the state variates per person.
> 
> I was complaining about speed a while ago, so after reading this post, I 
> thought I should try again and tell you:
> 
> The version in wireless-testing seems to work great, a test download 
> gave me 1.24MB/s, which is about the same speed I get with my (Intel 
> wireless) laptop. I am using rt2500pci.
> 
> Does the above mean that the stock driver in 2.6.25 will still be slow?

Most likely yes.
Although I hear mixed reports, some say it depends on the rate selection
algorithm, some claim rt2x00 in 2.6.24 is faster then wireless-testing and
others claim the exact opposite.
At the moment it is hard to tell, but I haven't collected data yet with specific
information about the used rate selection module and exact data transfer
numbers.

Ivo
