Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailguard.fgan.de ([128.7.3.5]:50352 "EHLO mailguard.fgan.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932553AbXKOGrC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2007 01:47:02 -0500
From: Henning Rogge <rogge@fgan.de>
To: Mike Kershaw <dragorn@kismetwireless.net>
Subject: Re: Virtual wireless network card for mac80211
Date: Thu, 15 Nov 2007 07:46:53 +0100
Cc: linux-wireless@vger.kernel.org
References: <200711141316.50393.rogge@fgan.de> <20071114155957.GB25925@drd1813.lan>
In-Reply-To: <20071114155957.GB25925@drd1813.lan>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200711150746.53999.rogge@fgan.de> (sfid-20071115_064709_469186_05126E07)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Mittwoch 14 November 2007 16:59:58 schrieb Mike Kershaw:
> Depending what you're trying to do, I did patches for tuntap that went
> in a year or two ago that allow you to set the link type and write
> radiotap/80211 frames.  Kismet-newcore (it's in branches in svn if you
> care) uses this to replicate mangled frames back out to other userspace
> programs.

> http://svn.kismetwireless.net/code/branch/kismet-newcore/dumpfile_tuntap.cc
Okay, that seems to be what I was looking for. It's not as flexible as a full 
virtual network card, but it has all features I need, thank you.

(it seems that none of the online documentation I found for tuntap contains 
this capability)

Henning
