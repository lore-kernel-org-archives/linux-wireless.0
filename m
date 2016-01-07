Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:35326 "EHLO
	mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbcAGQrm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2016 11:47:42 -0500
Received: by mail-io0-f177.google.com with SMTP id 77so227108864ioc.2
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jan 2016 08:47:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CABPxzYKaMPY6bz=Nr+W2wG5y_bV_wFN=7AMNUNcZNJBeVyYVJA@mail.gmail.com>
References: <CALnQHM3C=DVaTf58XDyh+rttVs-FSpc4ghozg9HJktEonq7w-g@mail.gmail.com>
	<568E913D.7050301@candelatech.com>
	<CALnQHM1mzqFbprQqujB7BWncOa=D9uAxLQ0paiv-21vrx+hFvw@mail.gmail.com>
	<CABPxzYKaMPY6bz=Nr+W2wG5y_bV_wFN=7AMNUNcZNJBeVyYVJA@mail.gmail.com>
Date: Thu, 7 Jan 2016 09:47:42 -0700
Message-ID: <CALnQHM3O6Z3E2wSkVLirDHCdT8vQqvQbqVEcSs8mfsfGs9KFyg@mail.gmail.com> (sfid-20160107_174746_130400_C248C7BD)
Subject: Re: lost connectivity until "wpa_cli reassociate" is issued
From: David Mosberger <davidm@egauge.net>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: Ben Greear <greearb@candelatech.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 7, 2016 at 9:32 AM, Krishna Chaitanya
<chaitanya.mgit@gmail.com> wrote:

> Management frames use a different queue (VO)
> from the logs it looks like a data path issue in driver/FW.
>
> The re-association might be clearing/triggering TX in driver
> solving the issue.

That sounds plausible to me.  Is there an easy way to see the queues?
I haven't tried debugfs yet.

  --david
-- 
eGauge Systems LLC, http://egauge.net/, 1.877-EGAUGE1, fax 720.545.9768
