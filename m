Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2832 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406Ab1HOG1U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Aug 2011 02:27:20 -0400
Message-ID: <4E48BC3C.3030303@broadcom.com> (sfid-20110815_082722_994352_63150639)
Date: Sun, 14 Aug 2011 23:27:08 -0700
From: "Franky Lin" <frankyl@broadcom.com>
MIME-Version: 1.0
To: "Tomasz Figa" <tomasz.figa@gmail.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend Van Spriel" <arend@broadcom.com>,
	"Kan Yan" <kanyan@broadcom.com>
Subject: Re: BCM4325 support in brcm80211 or newer versions of bcm4329
 driver
References: <1514181.3grperja2F@flatron>
In-Reply-To: <1514181.3grperja2F@flatron>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/14/2011 11:31 AM, Tomasz Figa wrote:
> I did some reasearch and it led me to a newer version of the DHD driver,
> designed for BCM4329 (v. 4.218), which after some modifications (BCD protocol
> version 2, some event IDs, etc.) started to work on my hardware, with one
> exception: waiting for RxCtrl after sending an "iscanresults" request times
> out. I'm attaching driver debug output at the bottom of this message.

Hi Tomasz,

RxCtrl time out is probably caused by Firmware crash. Based on your 
description this is the most likely reason. A mismatch between host 
driver and firmware is not recommended. Is it possible to switch to 
bcm4329 or get a newer firmware/host driver?

Franky

