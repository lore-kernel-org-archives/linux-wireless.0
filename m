Return-Path: <SRS0=sb9s=RE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62400C43381
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Mar 2019 21:38:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 306C52075B
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Mar 2019 21:38:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726007AbfCAViB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Mar 2019 16:38:01 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51391 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725982AbfCAViA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Mar 2019 16:38:00 -0500
Received: from mail-yw1-f72.google.com ([209.85.161.72])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <seth.forshee@canonical.com>)
        id 1gzpqw-00011o-KJ
        for linux-wireless@vger.kernel.org; Fri, 01 Mar 2019 21:37:58 +0000
Received: by mail-yw1-f72.google.com with SMTP id c188so23873367ywf.14
        for <linux-wireless@vger.kernel.org>; Fri, 01 Mar 2019 13:37:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=SX7zgQCRNjr1RHiwzvQcaiiIcPZ57ze844NNmiqc6CI=;
        b=nh5y2rHHItNEH1glS+6raNY2MfZzNZZox8jiof4VwxnV25tSyyO5LFEU5gfQjI1NaB
         UPUz0/gVxIszZnozKFUjSafSVC66QXdXwVvXbVWzm3H4Pp+P25f285O1zKNzQJHL81wv
         kq6D3FF3MCA4ytyQ+tjsovB7PxIZNYpl7K5vosy76fSTrVY01QKFaWXwYlBEAnXJDHX9
         LmxSDQJCrFZFEF1VH0BlnWb9yV/nIeYkTnGvESbVepmEBmSZbSE94yV5oZxI2KKTl3/W
         r9U8NoklDHjetvyIXYBxEl5QWSDfj/iSetBj5Z2nfEKODX/B5L7+FksnwafZTFFgqpr2
         u92A==
X-Gm-Message-State: APjAAAWR9+MrJoskBnLE3n8hajMSKZyICNIonJnoJS4YWLUmVocrU3Jk
        dM1ecJ6HYqKE+Rx6by4RmVu4ft/cepoZXb8jcRI0yiSAD0txQjshPl2kX/diJGCVnagLqdEeGJC
        Re+jEN9w43ZXLduqTC+pRAM+uxo7lh08Y+DqoMZBtLyvx
X-Received: by 2002:a25:6c88:: with SMTP id h130mr6066788ybc.240.1551476277396;
        Fri, 01 Mar 2019 13:37:57 -0800 (PST)
X-Google-Smtp-Source: APXvYqwCLbEkvsxZJlq2cvVDeUysFnVMITT4ytzvZqX2fLY2Tnxwn82psBCaza4w0mU14uIul3DeoQ==
X-Received: by 2002:a25:6c88:: with SMTP id h130mr6066771ybc.240.1551476277085;
        Fri, 01 Mar 2019 13:37:57 -0800 (PST)
Received: from localhost ([2605:a601:ac2:fb20:3179:3666:19da:e037])
        by smtp.gmail.com with ESMTPSA id p3sm12820817ywp.44.2019.03.01.13.37.55
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 01 Mar 2019 13:37:56 -0800 (PST)
Date:   Fri, 1 Mar 2019 15:37:54 -0600
From:   Seth Forshee <seth.forshee@canonical.com>
To:     wireless-regdb@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org
Subject: [ANN] wireless-regdb: master-2019-03-01
Message-ID: <20190301213754.GH22074@ubuntu-xps13>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

A new release of wireless-regdb (master-2019-03-01) is available at:

https://www.kernel.org/pub/software/network/wireless-regdb/wireless-regdb-2019.03.01.tar.gz

The short log of changes since the 2018-10-24 release is below.

Thanks,
Seth

---

Chaitanya Tata (1):
      wireless-regdb: update 60ghz band rules for us

Felix Fietkau (1):
      wireless-regdb: Sync IN with G.S.R. 1048(E), October 2018

Peter Lundkvist (1):
      wireless-regdb: Update regulatory rules for Sweden (SE) on 2.4/5/60 GHz

Rui Salvaterra (1):
      wireless-regdb: Add 5725-5875 MHz rule for Portugal (PT)

Seth Forshee (1):
      wireless-regdb: update regulatory database based on preceding changes

Xose Vazquez Perez (2):
      wireless-regdb: delete outdated comment for DE
      wireless-regdb: add URLs in README
