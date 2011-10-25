Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.ukfsn.org ([77.75.108.3]:60533 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753369Ab1JYS2M (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Oct 2011 14:28:12 -0400
Received: from localhost (smtp-filter.ukfsn.org [192.168.54.205])
	by mail.ukfsn.org (Postfix) with ESMTP id A0FA4DEBA2
	for <linux-wireless@vger.kernel.org>; Tue, 25 Oct 2011 19:10:39 +0100 (BST)
Received: from mail.ukfsn.org ([192.168.54.25])
	by localhost (smtp-filter.ukfsn.org [192.168.54.205]) (amavisd-new, port 10024)
	with ESMTP id 6JwJ0mOfYYHw for <linux-wireless@vger.kernel.org>;
	Tue, 25 Oct 2011 19:26:09 +0100 (BST)
Received: from stargate.localnet (unknown [84.45.236.142])
	by mail.ukfsn.org (Postfix) with ESMTP id 749ECDEB9E
	for <linux-wireless@vger.kernel.org>; Tue, 25 Oct 2011 19:10:39 +0100 (BST)
From: David Goodenough <david.goodenough@btconnect.com>
To: linux-wireless@vger.kernel.org
Subject: How to find the phy's associated with a wireless dev
Date: Tue, 25 Oct 2011 19:10:37 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201110251910.37638.david.goodenough@btconnect.com> (sfid-20111025_202816_801838_1C968992)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I notice that if I remove the kernel module for a wireless 
interface and reload it, that a new phy is defined.  This is 
confusing my script that sets up interfaces, in particular I 
need to set the distance for a long distance link and that has
to be done on the phy not the dev.

I am doing this from a script so I guess it has to be a query
using iw, but I can not see which one to use.

David
