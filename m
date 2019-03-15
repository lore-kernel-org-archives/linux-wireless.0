Return-Path: <SRS0=bI0Y=RS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74995C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 09:21:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E3142184C
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 09:21:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728669AbfCOJVg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Mar 2019 05:21:36 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:58568 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728627AbfCOJVg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Mar 2019 05:21:36 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC5)
        (envelope-from <johannes@sipsolutions.net>)
        id 1h4j1x-0005rB-Ap; Fri, 15 Mar 2019 10:21:33 +0100
Message-ID: <357340895a5e8641d15338702c36cd5e5baa0578.camel@sipsolutions.net>
Subject: Re: wireless workshop coming soon :-)
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Kevin Hayes <kevinhayes@chromium.org>,
        Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Kirtika Ruchandani <kirtika@google.com>
Cc:     linux-wireless@vger.kernel.org
Date:   Fri, 15 Mar 2019 10:21:32 +0100
In-Reply-To: <1d87a40795765be3ce9a485381c2867b143f26e1.camel@sipsolutions.net> (sfid-20190315_102014_772744_D4402D78)
References: <f90f210372b8c7f7efae0c43ab3ae925c334bc0e.camel@sipsolutions.net>
         <871s3qn91h.fsf@toke.dk>
         <5d26367411cf2b50d4cf237640598d1952f17673.camel@sipsolutions.net>
         <87y35ylty3.fsf@toke.dk>
         <CAPJUEh3s-Bs6dKrDG54Q1Wu2+1+kwMvTDxJxxEAVBanLA0=FYA@mail.gmail.com>
         (sfid-20190311_042135_753870_54906ED7) <1d87a40795765be3ce9a485381c2867b143f26e1.camel@sipsolutions.net>
         (sfid-20190315_102014_772744_D4402D78)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 2019-03-15 at 10:20 +0100, Johannes Berg wrote:
> On Sun, 2019-03-10 at 20:21 -0700, Kevin Hayes wrote:
> > [resending after html mode got nacked..]
> > 
> > Hi Johannes/Toke,
> > It would be fine with Kan and me to push the airtime fairness
> > discussion to later, to accomodate Toke.
> > Workshop fairness in action.  :)
> 
> :)
> Yes, I know we need to do that. Unfortunately I haven't had a chance to
> really build up a time-based agenda.
> 
> Let's see. We have track 4 all day on Wednesday, overlaps are:
> 
>               | track 1 | track 2 | track 3
>  8:30 - 10:30 | TCP     | XDP tut | IoT / U-LPWA
> 10:50 - 11:50 | TCP     | Kubrnts | FRR
> 11:50 - 12:20 | netlink | QUIC    | FRR dataplane
> 13:20 - 14:20 | netlink | QUIC    | -
> 14:40 - 16:10 | TC      | NF      | -
> 16:30 - 18:00 | hw offl | preempt | -
> 
> So the overlaps I know about are the XDP Tutorial (Toke) and netlink
> (partially at least, myself).
> 
> Any others?
> 
> Clearly Toke needs to be at the full XDP Tutorial, I think I can live
> with just doing the first part of the netlink workshop, according to
> their (tentative) agenda.
> 
> As far as I'm concerned, we need Toke for the eBPF/XDP wifi topic, and
> clearly for all the topics related to TXQs, which includes at least part
> of HE/11ax. Toke, is there anything else you have a strong interest in?
> 
> 
> So tentatively, I'd say you can do w/o me for the FQ/airtime fairness
> stuff (right Toke, Kalle?) and talk about that at 11:50?
> 
> 
> 
> Just randomly dropping the other stuff, I get:
> 
> (T = no Toke, J = no Johannes)
> 
>  8:30 -  9:00 T intro / CRDA deprecation / other regulatory topics?
>  9:00 -  9:30 T CSI reporting / vendor command/event handling updates
>  9:30 - 10:00 T nl80211 APIs - non-public features, NAN deprecation
> 10:00 - 10:30 T nl80211 APIs cont'd - Android
> 10:50 - 11:20   eBPF integration / XDP support for wifi
> 11:20 - 11:50   (buffer)
> 11:50 - 12:20 J rtw88 / grill Kalle (be)fore lunch ;-)
> 13:20 - 13:50   Kevin/Kan chromiumOS fairness review, bufferbloat plans
> 13:50 - 14:20   fq_codel / airtime fairness stack integration
> 14:40 - 15:10   HE/11ax status, timeline, testing, future work
> 15:10 - 15:40   HE/11ax TXQ AP-side (is anyone doing something here?)
> 15:40 - 16:10   release discussions (iw, wpa_s, ...)
> 16:30 - 17:00   security issue handling w/ backports
> 17:00 - 17:30   (buffer)
> 17:30 - 18:00

Oh, I have another idea - radiotap TLV format discussion, if anyone
cares?

johannes

