Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44339 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751014AbcLRUOQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 18 Dec 2016 15:14:16 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uBIK8qg2104221
        for <linux-wireless@vger.kernel.org>; Sun, 18 Dec 2016 15:14:16 -0500
Received: from e38.co.us.ibm.com (e38.co.us.ibm.com [32.97.110.159])
        by mx0b-001b2d01.pphosted.com with ESMTP id 27dkffx4aa-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-wireless@vger.kernel.org>; Sun, 18 Dec 2016 15:14:09 -0500
Received: from localhost
        by e38.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-wireless@vger.kernel.org> from <paulmck@linux.vnet.ibm.com>;
        Sun, 18 Dec 2016 13:14:08 -0700
Date: Sun, 18 Dec 2016 12:14:10 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>
Cc: Tobias Klausmann <tobias.johannes.klausmann@mni.thm.de>,
        Gabriel C <nix.or.die@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        ath9k-devel <ath9k-devel@qca.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nbd@nbd.name" <nbd@nbd.name>
Subject: Re: regression: ath_tx_edma_tasklet() Illegal idle entry in RCU
 read-side critical section
Reply-To: paulmck@linux.vnet.ibm.com
References: <23a2a3ab-974a-ed26-6afa-aafab9bb972e@gmail.com>
 <20161218155938.GP3924@linux.vnet.ibm.com>
 <58b67d5b-0275-f80f-479f-78cf748b4319@mni.thm.de>
 <87pokpc8ng.fsf@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87pokpc8ng.fsf@qca.qualcomm.com>
Message-Id: <20161218201410.GS3924@linux.vnet.ibm.com> (sfid-20161218_211509_912239_BEB16482)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Dec 18, 2016 at 07:57:42PM +0000, Valo, Kalle wrote:
> Tobias Klausmann <tobias.johannes.klausmann@mni.thm.de> writes:
> 
> > A patch for this is already floating on the ML for a while now latest:
> > (ath9k: do not return early to fix rcu unlocking)
> 
> It's here:
> 
> https://patchwork.kernel.org/patch/9472709/

Feel free to add:

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

							Thanx, Paul

> > Hopefully Kalle will include it in one of his upcoming pull requests.
> 
> Yes, I'll try to get it to 4.10-rc2.
> 
> -- 
> Kalle Valo
