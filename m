Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58048 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751474AbdBOK7s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Feb 2017 05:59:48 -0500
Message-ID: <1487156384.4026.22.camel@sipsolutions.net> (sfid-20170215_115952_185991_C66739BF)
Subject: Re: [RFC V2 1/5] nl80211: allow multiple active scheduled scan
 requests
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 15 Feb 2017 11:59:44 +0100
In-Reply-To: <83361d12-d793-380d-6eec-7191f3d10d9f@broadcom.com> (sfid-20170215_115514_772277_DA8A1ABA)
References: <1484566941-27000-1-git-send-email-arend.vanspriel@broadcom.com>
         <1484566941-27000-2-git-send-email-arend.vanspriel@broadcom.com>
         <1485250815.7244.8.camel@sipsolutions.net>
         <fd4c2573-caea-1cdc-ee33-f010bb0aad58@broadcom.com>
         <1487076714.4705.11.camel@sipsolutions.net>
         <deef3e83-b6d8-f99d-516d-dc6e99013560@broadcom.com>
         <1487077927.4705.14.camel@sipsolutions.net>
         <e2ec8547-4e0d-881b-5f4e-1e61d4b8b047@broadcom.com>
         <1487103101.6517.1.camel@sipsolutions.net>
         <83361d12-d793-380d-6eec-7191f3d10d9f@broadcom.com>
         (sfid-20170215_115514_772277_DA8A1ABA)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Ok. Now I bumped into a nice comment which I should have seen earlier
> ;-)

:-)

> Oh, well. So actually the sched_scan_plan attributes in case 0
> slipped through the cracks.

Oh. I guess we can still fix some things, but then again the iw version
that added support for split dumps was 4 years ago ...

johannes
