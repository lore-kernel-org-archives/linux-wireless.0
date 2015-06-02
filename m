Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:24748 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759274AbbFBPXy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2015 11:23:54 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org
To: Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH v3 0/2] 60 GHz rules update
Date: Tue,  2 Jun 2015 18:23:46 +0300
Message-Id: <1433258628-7047-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150602_172408_959409_67A961A1)
In-Reply-To: <20150602144231.GA31648@ubuntu-hedt>
References: <20150602144231.GA31648@ubuntu-hedt>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update for the 60 GHz rules for 2 countries - Japan and Russia.

Rebase and re-sending to the right maintainer, thus mark as "v3"
to avoid mis-interpretation

Vladimir Kondratiev (2):
  wireless-regdb: Add 60GHz regulatory rules for Japan (JP)
  wireless-regdb: Add 60GHz regulatory rules for Russia (RU)

 db.txt | 5 +++++
 1 file changed, 5 insertions(+)

-- 
2.1.4

