Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:38655 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754Ab2EPIGq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2012 04:06:46 -0400
Received: by qcro28 with SMTP id o28so259351qcr.19
        for <linux-wireless@vger.kernel.org>; Wed, 16 May 2012 01:06:45 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CADYPuQ54joKvzJEyTU+sjHFCPDqzizZL7_HfJwLi9VE-=+ETVQ@mail.gmail.com>
References: <CADYPuQ5U-TeJvaWdLA=kTgLRacMRyEPoi2aoB=PV-cx_YDXotg@mail.gmail.com>
	<CANUX_P3=G_ooQ_ODCKPXQxt9vkJZpbRV083CUBitof5mEVo6kw@mail.gmail.com>
	<CADYPuQ54joKvzJEyTU+sjHFCPDqzizZL7_HfJwLi9VE-=+ETVQ@mail.gmail.com>
Date: Wed, 16 May 2012 10:06:45 +0200
Message-ID: <CA+icZUVEAvwdQiKPaEVtVRNZoHTCnrHdKet0kbAN2wQccW-+_Q@mail.gmail.com> (sfid-20120516_100652_928047_9BE08794)
Subject: Re: frequent disconnects with iwlwifi
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Philipp Dreimann <philipp@dreimann.net>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>, johannes.berg@intel.com,
	wey-yi.w.guy@intel.com, ilw@linux.intel.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 15, 2012 at 2:14 PM, Philipp Dreimann <philipp@dreimann.net> wrote:
> On 15 May 2012 13:18, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
>> On Mon, May 14, 2012 at 10:39 PM, Philipp Dreimann <philipp@dreimann.net> wrote:
>> Sedat, your business is doing well. You have another customer. This is
>> a bug in NM. Sedat will provide details :-)
>
> I saw Sedat's posts and wanted to try disabling ipv6 handling in NM
> first to see if it helps. And, yes, it does.
>
> Cheers

Normally, I am used a classic /etc/network/interfaces file to
configure my network environment, but Ubuntu/precise shipped NM and I
gave it a try.

To (disable) ignore IPv6 in NM seems to be the easiest way.
Alternatively, I have added debdiffs for re-packaging a NM version w/o
this misbehaviour.

Just follow news on Ubuntu LP #988183.

- Sedat -
