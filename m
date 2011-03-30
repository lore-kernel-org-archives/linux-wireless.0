Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8501 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754847Ab1C3TPU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2011 15:15:20 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p2UJFJCd030655
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Wed, 30 Mar 2011 15:15:20 -0400
Received: from savage.usersys.redhat.com (savage.devel.redhat.com [10.11.231.4])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p2UJFJY8020413
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Wed, 30 Mar 2011 15:15:19 -0400
Received: from savage.usersys.redhat.com (localhost.localdomain [127.0.0.1])
	by savage.usersys.redhat.com (8.13.1/8.13.1) with ESMTP id p2UJFIM3012522
	for <linux-wireless@vger.kernel.org>; Wed, 30 Mar 2011 15:15:18 -0400
Received: (from linville@localhost)
	by savage.usersys.redhat.com (8.13.1/8.13.1/Submit) id p2UJFI1F012521
	for linux-wireless@vger.kernel.org; Wed, 30 Mar 2011 15:15:18 -0400
Date: Wed, 30 Mar 2011 15:15:18 -0400
From: "John W. Linville" <linville@redhat.com>
To: linux-wireless@vger.kernel.org
Subject: wireless-testing rebased on 2.6.39-rc1
Message-ID: <20110330191518.GC11368@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wireless-testing has been rebased -- I know the rebasing can be
painful, but it helps to keep the kruft from getting too deep in a
tree like wireless-testing.

Please updates your trees accordingly!

John
-- 
John W. Linville		The truth will set you free, but first it will
linville@redhat.com			make you miserable. -- James A. Garfield
