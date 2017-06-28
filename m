Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54816 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751500AbdF1KHi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Jun 2017 06:07:38 -0400
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        brcm80211-dev-list.pdl@broadcom.com
From: Hans de Goede <hdegoede@redhat.com>
Subject: brcmfmac4356-pci device not seeing 2.4Ghz channel 12 and 13
Message-ID: <f1a4e94b-1fb8-f1dc-ad64-d7de3533d64b@redhat.com> (sfid-20170628_120742_309448_B9EBD996)
Date: Wed, 28 Jun 2017 12:07:35 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I noticed today that my GPD Win (x86 clamshell mini laptop)
which uses a brcmfmac4356-pci wifi does not see an APs which
is using channel 13.

I've tried updating brcmfmac4356-pci.txt changing "ccode=US"
to "ccode=EU" and then rebooted, but that does not help.

I believe that the Linux wifi stack is supposed to automatically
figure out the country settings based on AP provided info ?

But that does not seem to be working here ? Any hints on howto
debug this further would be appreciated.

Regards,

Hans
