Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:38806 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbcAGRc6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2016 12:32:58 -0500
Received: by mail-ig0-f176.google.com with SMTP id mw1so58021387igb.1
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jan 2016 09:32:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <568E997C.1030003@einfach.org>
References: <CALnQHM3C=DVaTf58XDyh+rttVs-FSpc4ghozg9HJktEonq7w-g@mail.gmail.com>
	<568E913D.7050301@candelatech.com>
	<CALnQHM1mzqFbprQqujB7BWncOa=D9uAxLQ0paiv-21vrx+hFvw@mail.gmail.com>
	<568E997C.1030003@einfach.org>
Date: Thu, 7 Jan 2016 10:32:57 -0700
Message-ID: <CALnQHM2y=Uj4AUZDXL1tqgMbebbkaj2UF1HPMmXfbK-X8rsSjA@mail.gmail.com> (sfid-20160107_183301_928464_C2F7B382)
Subject: Re: lost connectivity until "wpa_cli reassociate" is issued
From: David Mosberger <davidm@egauge.net>
To: Bruno Randolf <br1@einfach.org>
Cc: Ben Greear <greearb@candelatech.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 7, 2016 at 9:59 AM, Bruno Randolf <br1@einfach.org> wrote:

> Although I have not checked if the "wpa_cli reassociate" command helps,
> I have seen rtl8192cu get "stuck" in similar ways. Maybe you can give
> the new rtl8xxxu driver from Jes Sorensen try? It has less features, but
> works more reliable, IMHO...

Oh, boy, switching to a completely different driver is not what I'd
like to do at this
stage, but perhaps it's the right thing to do.  Thanks for the suggestion!

I'll check with Jes.

  --david
-- 
eGauge Systems LLC, http://egauge.net/, 1.877-EGAUGE1, fax 720.545.9768
